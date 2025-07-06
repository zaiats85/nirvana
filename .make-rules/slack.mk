SLACK_CHANNEL ?= YOUR_SLACK_CHANNEL
SLACK_TOKEN ?= YOUR_SLACK_TOKEN
SLACK_POST_MESSAGE_URL ?= https://slack.com/api/chat.postMessage
SLACK_DEPLOYMENT_NOTIFICATION_TARGET_NAME ?= production
SLACK_DEPLOYMENT_NOTIFICATION_TARGET_URL ?= https://www.your-production-page.com
SLACK_DEPLOYMENT_NOTIFICATION_BUILD_URL ?= https://www.your-ci-build.com
SLACK_DEPLOYMENT_GREETING ?= Hey

.PHONY: slack/notify-deployment-success
slack/notify-deployment-success:
	curl -X POST $(SLACK_POST_MESSAGE_URL) \
		-H "Authorization: Bearer $(SLACK_TOKEN)" \
 		-d "text=$(SLACK_DEPLOYMENT_GREETING), the last deployment to the <$(SLACK_DEPLOYMENT_NOTIFICATION_TARGET_URL)|$(SLACK_DEPLOYMENT_NOTIFICATION_TARGET_NAME) system> has successfully completed! :tada:" \
		-d "channel=$(SLACK_CHANNEL)"


.PHONY: slack/notify-deployment-failure
slack/notify-deployment-failure:
	curl -X POST $(SLACK_POST_MESSAGE_URL) \
		-H "Authorization: Bearer $(SLACK_TOKEN)" \
		-d "text=Hey$(SLACK_DEPLOYMENT_GREETING), the last deployment to the $(SLACK_DEPLOYMENT_NOTIFICATION_TARGET_NAME) system failed! :broken_heart: <$(SLACK_DEPLOYMENT_NOTIFICATION_BUILD_URL)|Check here for more information.>" \
		-d "channel=$(SLACK_CHANNEL)".

PHONY: slack/notify-deployment-cancelled
slack/notify-deployment-cancelled:
	curl -X POST $(SLACK_POST_MESSAGE_URL) \
		-H "Authorization: Bearer $(SLACK_TOKEN)" \
		-d "text=Hey$(SLACK_DEPLOYMENT_GREETING), the last deployment to the $(SLACK_DEPLOYMENT_NOTIFICATION_TARGET_NAME) system cancelled! :x: <$(SLACK_DEPLOYMENT_NOTIFICATION_BUILD_URL)|Check here for more information.>" \
		-d "channel=$(SLACK_CHANNEL)"
