Feature: switch_manager daemon
  Scenario: switch_manager listens on TCP 6653
    When I successfully run `switch_manager`
    And I successfully run `sleep 1`
    And I successfully run `netstat -an`
    Then the output should match /(\*\.|0\.0\.0\.0:)6653/

  @wip
  Scenario: switch_manager spawns switch_daemon
    Given I successfully run `switch_manager`
    When I successfully run `dummy_switch`
    And I successfully run `ps x`
    Then the output from "ps x" should contain "0xabc"

  Scenario: switch_manager listens on trema.switch_manager.sock
    When I successfully run `switch_manager`
    And I successfully run `sleep 1`
    And I successfully run `netstat -an`
    Then the output from "netstat -an" should contain "trema.switch_manager.sock"
