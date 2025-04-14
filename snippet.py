import os
from functools import cache
from typing import Any, Optional

from slack_sdk import WebClient
from slack_sdk.errors import SlackApiError
from slack_sdk.http_retry.builtin_handlers import RateLimitErrorRetryHandler

from src.library.common.environment import Environment
from src.logger import logger
from src.service.datadog_org_management.application import DatadogOrgManagementService
from src.service.role_management.application import RoleManagementService
from src.service.user_management.application import UserManagementService


class SlackAPIRepository:
    def __init__(self) -> None:
        token = os.getenv("SLACK_APP_TOKEN")
        self.client = WebClient(token)
        self.client.retry_handlers.append(RateLimitErrorRetryHandler(max_retry_count=1))

    def get_recipient_id_by_user_email(self, user_email: str) -> Optional[str]:
        try:
            user_id = self.client.users_lookupByEmail(email=user_email)
            if not user_id or "user" not in user_id:
                return None
            return user_id["user"].get("id")
        except SlackApiError as err:
            if err.response["error"] == "users_not_found":
                logger.warning("User %s not found on Slack - removing from databases", user_email)
                UserManagementService().remove_user(user_email)
                RoleManagementService().remove_user(user_email)
                DatadogOrgManagementService().remove_datadog_organization_owner(user_email)
            else:
                logger.exception("Slack API error while getting ID of user %s", user_email)

            return None

    def send_private(self, recipient_id: str, message: list, preview_text: str) -> None:
        processed_message = self._process_message(message)

        try:
            conversation = self.client.conversations_open(users=[recipient_id]) or {}
            self.client.chat_postMessage(
                channel=conversation.get("channel", {}).get("id"), blocks=processed_message, text=preview_text
            )
        except SlackApiError:
            logger.exception("Slack API error while sending private message to %s", recipient_id)

    def send_channel(self, channel_name: str, message: list, preview_text: str) -> None:
        processed_message = self._process_message(message)
        try:
            self.client.chat_postMessage(channel=channel_name, blocks=processed_message, text=preview_text)
        except SlackApiError:
            logger.exception("Slack API error while sending message to channel %s", channel_name)

    @cache
    def is_user_active(self, email: str) -> bool:
        resp = self.client.users_lookupByEmail(email=email)
        return resp["ok"] and resp.get("user", {}).get("deleted") is False

    @staticmethod
    def _process_message(message: list[Any]) -> list[Any]:
        if not Environment.is_prod():
            message.append(
                {
                    "type": "context",
                    "elements": [
                        {
                            "type": "image",
                            "image_url": "https://pbs.twimg.com/profile_images/625633822235693056/lNGUneLX_400x400.jpg",
                            "alt_text": "cute cat",
                        },
                        {
                            "type": "mrkdwn",
                            "text": f"Message sent from the XXX {Environment.get_name()}* environment.",
                        },
                    ],
                }
            )

        return message
