enum Abuse {
  violanceOrSexual,
  pedophilia,
  physicalViolance,
  sexual,
  human,
  animal,
  anotherViolanceOrSexual,
  hate,
  hatefulSpeechOrBehavior,
  bully,
  suicideOrSelfHarm,
  unhealtyBodyImage,
  promotingUnhealty,
  dangerousActivities,
  nudityOrSexual,
  youthSexualActivity,
  youthSexuallySuggestiveBehavior,
  adultSexualActivityServicesAndDemands,
  adultNudity,
  dirtyTalk,
  disturbingContent,
  incorrectInformation,
  electionMisinformation,
  harmfulMisinformation,
  fakeVideoManipulatedMedia,
  misleadingBehaviorOrSpam,
  fakeLikeOrFollow,
  spam,
  undisclosedBrandedContent,
  regulatedProductsOrActivities,
  gambling,
  alcoholTobaccoAndDrugs,
  firearmsAndDangerousWeapons,
  tradeInRegulatedProducts,
  fraud,
  sharingPersonalInfo,
  counterfeitProductsOrIntellectualProperty,
  imitationProducts,
  iAmEntitled,
  suspicionOfRightsViolation,
  intellectualPropertyRightViolation,
  another
}

Abuse abuseFromString(String abuse) {
  switch(abuse) {
    case "violance_or_sexual":
      return Abuse.violanceOrSexual;
    case "pedophilia":
      return Abuse.pedophilia;
    case "physical_violance":
      return Abuse.physicalViolance;
    case "sexual": 
      return Abuse.sexual;
    case "human":
      return  Abuse.human;
    case "animal":
      return Abuse.animal;
    case "another_violance_or_sexual":
      return  Abuse.anotherViolanceOrSexual;
    case "hate":
      return  Abuse.hate;
    case "hateful_speech_or_behavior":
      return  Abuse.hatefulSpeechOrBehavior;
    case "bully":
      return  Abuse.bully;
    case "suicide_or_self_harm":
      return  Abuse.suicideOrSelfHarm;
    case "unhealty_body_image":
      return  Abuse.unhealtyBodyImage;
    case "promoting_unhealty":
      return Abuse.promotingUnhealty;
    case "dangerous_activities":
      return Abuse.dangerousActivities;
    case "Abuse.dangerousActivities:":
      return Abuse.nudityOrSexual;
    case "youth_sexual_activity":
      return Abuse.youthSexualActivity;
    case "youth_sexually_suggestive_behavior":
      return Abuse.youthSexuallySuggestiveBehavior;
    case "adult_sexual_activity_services_and_demands":
      return Abuse.adultSexualActivityServicesAndDemands;
    case "adult_nudity":
      return  Abuse.adultNudity;
    case "dirty_talk":
      return Abuse.dirtyTalk;
    case "disturbing_content":
      return Abuse.disturbingContent;
    case "incorrect_information":
      return Abuse.incorrectInformation;
    case "fake_video_manipulated_media":
      return Abuse.fakeVideoManipulatedMedia;
    case "election_misinformation":
      return Abuse.electionMisinformation;
    case "harmful_misinformation":
      return Abuse.harmfulMisinformation;
    case "fake_like_or_follow":
      return Abuse.fakeLikeOrFollow;
    case "misleading_behavior_or_spam":
      return Abuse.misleadingBehaviorOrSpam;
    case "spam":
      return Abuse.spam;
    case "undisclosed_branded_content":
      return Abuse.undisclosedBrandedContent;
    case "regulated_products_or_activities":
      return Abuse.regulatedProductsOrActivities;
    case "gambling":
      return Abuse.gambling;
    case "alcohol_tobacco_and_drugs":
      return Abuse.alcoholTobaccoAndDrugs;
    case "firearms_and_dangerous_weapons":
      return Abuse.firearmsAndDangerousWeapons;
    case "trade_in_regulated_products":
      return Abuse.tradeInRegulatedProducts;
    case "fraud":
      return Abuse.fraud;
    case "sharing_personal_info":
      return Abuse.sharingPersonalInfo;
    case "counterfeit_products_or_intellectual_property":
      return Abuse.counterfeitProductsOrIntellectualProperty;
    case "imitation_products":
      return Abuse.imitationProducts;
    case "i_am_entitled":
      return Abuse.iAmEntitled;
    case "suspicion_of_rights_violation":
      return Abuse.suspicionOfRightsViolation;
    case "intellectual_property_right_violation":
      return Abuse.intellectualPropertyRightViolation;
    case "another":
      return Abuse.another;
    default: 
      return Abuse.another;
  }
}

String abuseToString(Abuse abuse) {
  switch(abuse) {
    case Abuse.violanceOrSexual:
      return "violance_or_sexual";
    case Abuse.pedophilia:
      return "pedophilia";
    case Abuse.physicalViolance:
      return "physical_violance";
    case Abuse.sexual:
      return "sexual";
    case Abuse.human:
      return "human";
    case Abuse.animal:
      return "animal";
    case Abuse.anotherViolanceOrSexual:
      return "another_violance_or_sexual";
    case Abuse.hate:
      return "hate";
    case Abuse.hatefulSpeechOrBehavior:
      return "hateful_speech_or_behavior";
    case Abuse.bully:
      return "bully";
    case Abuse.suicideOrSelfHarm:
      return "suicide_or_self_harm";
    case Abuse.unhealtyBodyImage:
      return "unhealty_body_image";
    case Abuse.promotingUnhealty:
      return "promoting_unhealty";
    case Abuse.dangerousActivities:
      return "dangerous_activities";
    case Abuse.nudityOrSexual:
      return "nudity_or_sexual";
    case Abuse.youthSexualActivity:
      return "youth_sexual_activity";
    case Abuse.youthSexuallySuggestiveBehavior:
      return "youth_sexually_suggestive_behavior";
    case Abuse.adultSexualActivityServicesAndDemands:
      return "adult_sexual_activity_services_and_demands";
    case Abuse.adultNudity:
      return "adult_nudity";
    case Abuse.dirtyTalk:
      return "dirty_talk";
    case Abuse.disturbingContent: 
      return "disturbing_content";
    case Abuse.incorrectInformation:
      return "incorrect_information";
    case Abuse.fakeVideoManipulatedMedia:
      return "fake_video_manipulated_media";
    case Abuse.electionMisinformation:
      return "election_misinformation";
    case Abuse.harmfulMisinformation:
      return "harmful_misinformation";
    case Abuse.fakeLikeOrFollow:
      return "fake_like_or_follow";
    case Abuse.misleadingBehaviorOrSpam:
      return "misleading_behavior_or_spam";
    case Abuse.spam:
      return "spam";
    case Abuse.undisclosedBrandedContent:
      return "undisclosed_branded_content";
    case Abuse.regulatedProductsOrActivities:
      return "regulated_products_or_activities";
    case Abuse.gambling:
      return "gambling";
    case Abuse.alcoholTobaccoAndDrugs:
      return "alcohol_tobacco_and_drugs";
    case Abuse.firearmsAndDangerousWeapons:
      return "firearms_and_dangerous_weapons";
    case Abuse.tradeInRegulatedProducts:
      return "trade_in_regulated_products";
    case Abuse.fraud:
      return "fraud";
    case Abuse.sharingPersonalInfo:
      return "sharing_personal_info";
    case Abuse.counterfeitProductsOrIntellectualProperty:
      return "counterfeit_products_or_intellectual_property";
    case Abuse.imitationProducts:
      return "imitation_products";
    case Abuse.iAmEntitled:
      return "i_am_entitled";
    case Abuse.suspicionOfRightsViolation:
      return "suspicion_of_rights_violation";
    case Abuse.intellectualPropertyRightViolation:
      return "intellectual_property_right_violation";
    case Abuse.another:
      return "another";
  }
}