import Tabs from "@theme/Tabs";
import TabItem from "@theme/TabItem";
import {Schema} from "./Schema";

export const SchemaExample = ({ path, children }) => {
    return (
        <Tabs>
            <TabItem value="example" label="Example">
                {children}
            </TabItem>
            <TabItem value="Schema" label="Schema">
                <Schema path={path} />
            </TabItem>
        </Tabs>
    )
}