import { action } from "@ember/object";
import { next } from "@ember/runloop";
import Service, { service } from "@ember/service";
import Composer from "discourse/models/composer";
import I18n from "discourse-i18n";

export default class HiddenSubmit extends Service {
  @service composer;
  @service dialog;

  inputValue = "";

  @action
  focusInput() {
    this.composer.close();
    next(() => {
      document.getElementById("aibot-modal-input").focus();
    });
  }

  @action
  async submitToBot() {
    const loadingCont = document.querySelector(".aibot-modal__main");
    loadingCont.classList.add("loading");
    
    this.composer.close();

    if (this.inputValue.length < 10) {
      loadingCont.classList.remove("loading");
      this.dialog.alert({
        message: I18n.t(themePrefix("input_length")),
        didConfirm: () => this.focusInput(),
        didCancel: () => this.focusInput(),
      });
    }

    await this.composer.open({
      action: Composer.PRIVATE_MESSAGE,
      draftKey: "private_message_ai",
      recipients: settings.aibot_username,
      topicTitle: I18n.t("discourse_ai.ai_bot.default_pm_prefix"),
      topicBody: this.inputValue,
      archetypeId: "private_message",
      warningsDisabled: true,
      skipDraftCheck: true,
      disableDrafts: true,
    });

    try {
      await this.composer.save();
      // Clear inputValue after successful submission
      this.inputValue = "";
    } catch (error) {
      // eslint-disable-next-line no-console
      console.error("Failed to submit message:", error);
    }
  }
}
