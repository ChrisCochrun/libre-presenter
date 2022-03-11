import QtQuick 2.13
import QtQuick.Dialogs 1.0
import QtQuick.Controls 2.15 as Controls
import QtQuick.Layouts 1.2
import org.kde.kirigami 2.13 as Kirigami
import "./" as Presenter
import org.presenter 1.0

Kirigami.OverlaySheet {

    property ListModel model

    id: root
    header: Kirigami.Heading {
        text: "Settings"
    }
    Kirigami.FormLayout {
	Controls.ComboBox {
	    id: screenSelectionField
	    Kirigami.FormData.label: i18nc("@label:textbox", "Screen:")
            model: model
            textRole: name
	    onAccepted: descriptionField.forceActiveFocus()
	}
	Controls.TextField {
	    id: descriptionField
	    Kirigami.FormData.label: i18nc("@label:textbox", "Description:")
	    placeholderText: i18n("Optional")
	    onAccepted: dateField.forceActiveFocus()
	}
	Controls.TextField {
	    id: dateField
	    Kirigami.FormData.label: i18nc("@label:textbox", "Date:")
	    placeholderText: i18n("YYYY-MM-DD")
	    inputMask: "0000-00-00"
	}
    }
}
