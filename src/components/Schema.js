import CodeBlock from '@theme/CodeBlock';
import {useState} from "react";
import './styles.schema.css';

export const Schema = ({ path }) => {
    const [schema, setSchema] = useState("")

    const get = () => fetch("https://static.echo-chat.au/schemas" + path, )
        .then(response => response.text())
        .then(data => {
            console.log(data)
            setSchema(data)
        })

    return (
        <CodeBlock title="Schema">
            <CodeBlock language="json">
                {schema}
            </CodeBlock>
            <div className="get-schema-button-wrapper">
                <button
                    onClick={get}
                    className="get-schema-button"
                >Get Schema
                </button>
            </div>
        </CodeBlock>
    )
}