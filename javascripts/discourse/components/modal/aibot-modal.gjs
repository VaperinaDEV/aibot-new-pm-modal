import Component from "@glimmer/component";
import { on } from "@ember/modifier";
import { action } from "@ember/object";
import didInsert from "@ember/render-modifiers/modifiers/did-insert";
import { service } from "@ember/service";
import { htmlSafe } from "@ember/template";
import replaceEmoji from "discourse/helpers/replace-emoji";
import DiscourseURL from "discourse/lib/url";
import DButton from "discourse/components/d-button";
import I18n from "discourse-i18n";
import i18n from "discourse-common/helpers/i18n";
import QuickButtons from "../quick-buttons";
import DModal from "discourse/components/d-modal";
import SimpleTextareaInteractor from "../../lib/simple-textarea-interactor";

export default class AiBotModal extends Component {
  @service hiddenSubmit;
  @service modal;

  textareaInteractor = null;

  @action
  updateInputValue(event) {
    this.hiddenSubmit.inputValue = event.target.value;
  }

  @action
  handleKeyDown(event) {
    if (event.key === "Enter" && !event.shiftKey) {
      this.hiddenSubmit.submitToBot();
    }
  }

  @action
  initializeTextarea(element) {
    this.textareaInteractor = new SimpleTextareaInteractor(element);
  }

  @action
  recentMessages() {
    DiscourseURL.routeTo("/search?q=in%3Amessages%20%40" + settings.aibot_username);
    this.modal.close();
  }

  get aiBotModalTitle() {
    return I18n.t(themePrefix("aibot_modal_title"));
  }

  get aiBotMessage() {
    return I18n.t(themePrefix("aibot_message"));
  }

  <template>
    <DModal
      @closeModal={{@closeModal}}
      @title={{this.aiBotModalTitle}}
      class="aibot-modal"
    >
      <:body>
        <div class="aibot-modal__main">
          <div class="aibot-modal__content-wrapper">
            <div class="aibot-modal__aibot-wrapper">
              <div class="aibot-avatar">
                <img
                  src="{{settings.aibot_avatar}}"
                  class="avatar"
                />
              </div>
              <span class="aibot-message">
                {{replaceEmoji (htmlSafe this.aiBotMessage)}}
              </span>
            </div>
            <QuickButtons />
            <div class="aibot-modal__input-wrapper">
              <textarea
                {{didInsert this.initializeTextarea}}
                {{on "input" this.updateInputValue}}
                {{on "keydown" this.handleKeyDown}}
                id="aibot-modal-input"
                placeholder={{i18n (themePrefix "input_placeholder")}}
                minlength="10"
                rows="1"
              />
              <DButton
                @action={{this.hiddenSubmit.submitToBot}}
                @icon="paper-plane"
                @translatedTitle={{i18n (themePrefix "input_submit")}}
                class="ai-bot-button btn-primary"
              />
            </div>
            <p class="ai-disclaimer">
              {{i18n (themePrefix "disclaimer")}}
            </p>
          </div>
        </div>
        <div class="ai-recent-messages">
          <DButton
            @action={{this.recentMessages}}
            @icon={{settings.aibot_recent_messages_icon}}
            @translatedLabel={{i18n (themePrefix "recent_messages")}}
            class="btn-transparent"
          />
        </div>
      </:body>
    </DModal>
  </template>
}
