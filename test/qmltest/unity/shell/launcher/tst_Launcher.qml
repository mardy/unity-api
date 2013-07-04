/*
 * Copyright 2013 Canonical Ltd.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * Authors:
 *      Michael Zanetti <michael.zanetti@canonical.com>
 */

import QtQuick 2.0
import QtTest 1.0
import TestUtil 0.1
import Unity.Launcher 0.1

Item {

    Verifier {
        id: checkModelVerifier

        property var model: LauncherModel

        function test_model_data() {
            return [
                { tag: "LauncherModel[object]", type: "object" },
                { tag: "LauncherModel[LauncherModelInterface]", type: "unity::shell::launcher::LauncherModelInterface" },
            ];
        }

        function test_model(data) {
            object = model;
            name = "LauncherModel"

            verifyData(data);
        }
    }

    Verifier {
        when: checkModelVerifier.completed

        Repeater {
            id: repeater
            model: LauncherModel
            delegate: Item {
                property var roles: model
            }
        }

        function initTestCase() {
            if (repeater.count < 5) {
                print("This Test Suite requires at least 5 items in the model.")
                fail()
            }
        }

        /* make sure all the required roles are exposed on Model */
        function test_model_roles_data() {
            return [
                        { tag: "Model.roles[desktopFile]", role: "desktopFile", type: "string" },
                        { tag: "Model.roles[name]", role: "name", type: "string" },
                        { tag: "Model.roles[icon]", role: "icon", type: "string" },
                        { tag: "Model.roles[pinned]", role: "pinned", type: "boolean" },
                        { tag: "Model.roles[running]", role: "running", type: "boolean" },
                        { tag: "Model.roles[recent]", role: "recent", type: "boolean" },
                        { tag: "Model.roles[progress]", role: "progress", type: "number" },
                        { tag: "Model.roles[count]", role: "count", type: "number" },
                    ];
        }

        function test_model_roles(data) {
            name = "LauncherModel"
            try {
                object = repeater.itemAt(0).roles;
            } catch(err) {
                object = undefined;
            }

            verifyData(data);
        }

        function test_model_methods_data() {
            return [
                        { tag: "Model.methods[get]", method: "get" },
                        { tag: "Model.methods[move]", method: "move" }
            ];
        }

        function test_model_methods(data) {
            name = "LauncherModel"
            object = LauncherModel;
            verifyData(data);
        }

        function test_item_properties_data() {
            return [
                        { tag: "Item.properties[desktopFile]", constant: "desktopFile", type: "string" },
                        { tag: "Item.properties[name]", constant: "name", type: "string" },
                        { tag: "Item.properties[icon]", constant: "icon", type: "string" },
                        { tag: "Item.properties[pinned]", property: "pinned", type: "boolean" },
                        { tag: "Item.properties[recent]", property: "recent", type: "boolean" },
                        { tag: "Item.properties[running]", property: "running", type: "boolean" },
                        { tag: "Item.properties[progress]", property: "progress", type: "number" },
                        { tag: "Item.properties[count]", property: "count", type: "number" },
                        { tag: "Item.properties[quickList]", constant: "quickList", type: "object" },
                    ];
        }

        function test_item_properties(data) {
            name = "LauncherItem"
            try {
                object = LauncherModel.get(0)
            } catch(err) {
                object = undefined;
                print(err)
            }

            verifyData(data)
        }

        function test_move() {
            var item0 = LauncherModel.get(0)
            var item1 = LauncherModel.get(1)
            var item2 = LauncherModel.get(2)
            var item3 = LauncherModel.get(3)

            LauncherModel.move(2, 0);

            compare(item2, LauncherModel.get(0), "Error moving Items im model")
            compare(item0, LauncherModel.get(1), "Error moving Items im model")
            compare(item1, LauncherModel.get(2), "Error moving Items im model")
            compare(item3, LauncherModel.get(3), "Error moving Items im model")
        }

        function test_pinning() {
            var item0 = LauncherModel.get(0)
            signalSpy.clear()
            signalSpy.target = item0
            signalSpy.signalName = "pinnedChanged"
            compare(item0.pinned, false, "Item is already pinned. Cannot test pinning.")
            LauncherModel.pin(0)
            compare(signalSpy.count, 1, "Item did not emit pinnedChanged.")
            compare(item0.pinned, true, "Items pinned state did not change to true.")
        }

        function test_remove() {
            var currentCount = repeater.count
            LauncherModel.remove(4)
            compare(repeater.count, currentCount - 1, "Remove did not succeed.")
        }

        SignalSpy {
            id: signalSpy
        }
    }
}
