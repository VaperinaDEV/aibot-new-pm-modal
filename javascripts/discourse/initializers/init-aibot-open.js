import { apiInitializer } from "discourse/lib/api";
import SidebarAiBotButton from "../components/sidebar-aibot-button";

export default apiInitializer("1.8.0", (api) => {
  const currentUser = api.getCurrentUser();
  let showUserGroup = false;

  if (currentUser && currentUser.groups){
    for (var i=0; i < currentUser.groups.length; i++) {
      if (settings.show_for_groups.split("|").includes(currentUser.groups[i].name)){
        showUserGroup = true;
      }
    }
  }

  if (!showUserGroup) {
    return;
  }
  
  api.renderInOutlet(settings.sibebar_aibot_button_postition, SidebarAiBotButton);
});
