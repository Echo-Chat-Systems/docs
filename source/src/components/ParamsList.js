import Heading from "@theme/Heading";

export const ParamsList = ({ children }) => {
    return (
        <div>
            <Heading as="h3">Parameters</Heading>
            <div>
                {children}
            </div>
        </div>
    )
}
