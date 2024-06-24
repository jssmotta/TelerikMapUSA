<%@ Page Language="C#" CodeBehind="MapUSA.aspx.cs" Inherits="Demo.MapaUSA" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Title</title>
    <style>
        .k-tooltip-content {
            color: black;
        }
    </style>
</head>
<body>
    <form id="HtmlForm" runat="server" style="width: 100%; height: 100vh;">
        <telerik:RadScriptManager LoadScriptsBeforeUI="true" ScriptMode="Release" EnableScriptCombine="false" ID="RadScriptManager1" runat="server" EnablePageMethods="true" EnableViewState="true" EnablePartialRendering="True" EnableScriptGlobalization="true" EnableTheming="True">
            <Scripts>
                <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.Core.js" />
                <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.jQuery.js" />
                <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.jQueryInclude.js" />
            </Scripts>
        </telerik:RadScriptManager>
        <telerik:RadFormDecorator ID="RadFormDecorator1" DecoratedControls="All" Skin="Bootstrap" runat="server" SkinID="Vista"></telerik:RadFormDecorator>
        <telerik:RadStyleSheetManager ID="RadStyleSheetManager1" runat="server"></telerik:RadStyleSheetManager>

        <div>
            <telerik:RadMap Height="1000px" ID="RadMap1" runat="server" Zoom="5" LayersDataSourceID="RadClientDataSource1">
                <CenterSettings Latitude="43.2681" Longitude="-97.7448" />
                <ClientEvents OnShapeCreated="onShapeCreated" OnShapeFeatureCreated="onShapeFeatureCreated"
                    OnShapeMouseEnter="onShapeMouseEnter" OnShapeMouseLeave="onShapeMouseLeave" />
                <LayersCollection>
                    <telerik:MapLayer Type="Shape" ClientDataSourceID="RadClientDataSource1">
                        <StyleSettings>
                            <FillSettings Opacity="0.7" />
                        </StyleSettings>
                    </telerik:MapLayer>
                </LayersCollection>
            </telerik:RadMap>

            <telerik:RadClientDataSource ID="RadClientDataSource1" runat="server">
                <DataSource>
                    <WebServiceDataSourceSettings ServiceType="GeoJSON">
                        <Select Url="states.json" DataType="JSON" />
                    </WebServiceDataSourceSettings>
                </DataSource>
            </telerik:RadClientDataSource>
        </div>
        <telerik:RadCodeBlock runat="server">

            <script>

                // Data for the states with random values              
                const dataStates = [['Alabama', 141.972], ['Alaska', 1.896], ['Arizona', 85.57], ['Arkansas', 84.64], ['California', 362.54], ['Colorado', 73.99], ['Connecticut', 1108.65], ['Delaware', 696.45], ['District of Columbia', 15097.5], ['Florida', 530.09], ['Georgia', 254.25], ['Hawaii', 321.15], ['Hawaii', 321.15], ['Idaho', 28.72], ['Illinois', 347.25], ['Indiana', 272.54], ['Iowa', 82.215], ['Kansas', 52.63], ['Kentucky', 165], ['Louisiana', 157.5], ['Maine', 64.56], ['Maryland', 894.44], ['Maryland', 894.44], ['Massachusetts', 1260.30], ['Michigan', 260.85], ['Michigan', 260.85], ['Michigan', 260.85], ['Michigan', 260.85], ['Minnesota', 100.71], ['Mississippi', 95.25], ['Missouri', 130.89], ['Montana', 10.28], ['Nebraska', 35.95], ['Nevada', 37.2], ['New Hampshire', 220.5], ['New Jersey', 1783.5], ['New Mexico', 25.74], ['New York', 618.45], ['North Carolina', 297.29], ['North Dakota', 14.874], ['Ohio', 422.84], ['Oklahoma', 82.83], ['Oregon', 60.495], ['Pennsylvania', 426.45], ['Rhode Island', 1509], ['South Carolina', 233.10], ['South Dakota', 147.105], ['Tennessee', 132.12], ['Texas', 147.10], ['Utah', 51.44], ['Vermont', 101.595], ['Virginia', 306.75], ['Virginia', 306.75], ['Virginia', 306.75], ['Washington', 153.89], ['Washington', 153.89], ['Washington', 153.89], ['West Virginia', 115.59], ['Wisconsin', 157.8], ['Wyoming', 8.7765], ['Puerto Rico', 16]];

                const PMinWidthToDisplayLabel = 50;

                function onShapeCreated(e) {

                    var shape = e.shape;
                    var key = shape.dataItem.properties.name;
                    var valueArray = dataStates.find(function (item) {
                        if (item[0] === key) return item;
                    });

                    var customValue = parseFloat(valueArray[1]);

                    if (customValue > 150) {
                        shape.options.fill.set("color", "red"); // Red for values greater than 150
                    } else {
                        shape.options.fill.set("color", "blue"); // Green otherwise
                    }

                    var bbox = e.shape.bbox(); // Get the "box" of each of the states

                    if (bbox.width() <= PMinWidthToDisplayLabel) {
                        return;
                    }

                    var options = { style: 'currency', currency: 'USD' };
                    var labelText = customValue.toLocaleString('en-US', options);

                    var center = bbox.center(); // We need the center, in order to later display the label exactly on it.
                    var label = new kendo.drawing.Text(labelText);
                    label.options.fill.color = "#DEDEDE"; // Set the color to white
                    var labelCenter = label.bbox().center();

                    label.position([ // Position the label
                        center.x - labelCenter.x,
                        center.y - labelCenter.y
                    ]);

                    e.layer.surface.draw(label); // Render the label on the layer surface

                }

                function onShapeFeatureCreated(e) {

                    var key = e.properties.name;
                    var valueArray = dataStates.find(function (item) {
                        if (item[0] === key) return item;
                    });

                    var customValue = parseFloat(valueArray[1]);

                    var options = { style: 'currency', currency: 'USD' };
                    var tooltipText = customValue.toLocaleString('en-US', options);

                    e.group.options.tooltip = {
                        content: e.properties.name + " - " + tooltipText,
                        position: "cursor",
                        offset: 10,
                        width: 120
                    };
                }

                function onShapeMouseEnter(e) {
                    e.shape.options.set("fill.opacity", 1);
                }

                function onShapeMouseLeave(e) {
                    e.shape.options.set("fill.opacity", 0.7);
                }

            </script>
        </telerik:RadCodeBlock>
    </form>
</body>
</html>
