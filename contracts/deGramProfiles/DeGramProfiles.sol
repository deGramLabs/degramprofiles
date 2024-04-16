// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

/**
 * @title DeGramProfiles
 * @dev A contract for registering and managing profile names on the blockchain.
 * @custom:security-contact security@degram.io
 * @name: deGram Profiles
 * @author: Charan Madhu {deGram: @charan} {email:charan@degram.io}
 *
 *       @@@@@@@@@@@                                                                                   
 *    @@@@@@@@@@@@@@@@                                                                                
 * @@@@@@@@@@@@@@@@@@@@@@          @@@                  @@@@                                          
 * @@@@@@@@@@@@@@@@@@@@@@@         @@@@              @@@@@@@@@@                                       
 *@@@@@@@@@@@@@@@@@@@@@@@@    @@@@@@@@@   @@@@@@    @@@@@   @@   @@@@@@@   @@@@@@@@  @@@@@@@@ @@@@@@  
 *@@@@@@@    @@    @@@@@@@@ @@@@@@@@@@@ @@@@  @@@@ @@@@          @@@@@@@ @@@@@@@@@@@ @@@@@@@@@@@@@@@@ 
 *@@@@@@@    @@    @@@@@@@@@@@@    @@@@ @@@@  @@@@ @@@@  @@@@@@@ @@@    @@@@    @@@@ @@@   @@@@   @@@ 
 *@@@@@@@@@@@@@@@@@@@@@@@@ @@@@    @@@@ @@@@@@@@@@ @@@@     @@@@ @@@    @@@@    @@@@ @@@   @@@@   @@@ 
 *@@@@@@@@@@@@@@@@@@@@@@@@  @@@@@@@@@@@ @@@@@       @@@@@@@@@@@@ @@@     @@@@@@@@@@@ @@@   @@@@   @@@ 
 *@@@@@@@@@@@@@@@@@@@@@@@    @@@@@@@@@   @@@@@@@@     @@@@@@@@@  @@@      @@@@@@@@@@ @@@   @@@@   @@@ 
 *@@@@@@@@@@@@@@@@@@@@                                                                                
 *@@@@@@@@@@@@@@@@@                                                                                   
*/

// Importing Reaquired contracts
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol"; 
import {StringUtils} from "contracts/deGramProfiles/libraries/StringUtils.sol";
import {Base64} from "contracts/deGramProfiles/libraries/Base64.sol";
import "contracts/deGramProfiles/whitelisting/DeGramWhitelist.sol";


/**
 * @title DeGramProfiles
 * @dev A contract for registering and managing profile names on the blockchain.
 * Each profile is represented as an ERC721 token, with the profile name as the token's metadata.
 * Admins can issue the badges to the profiles.
 */
contract DeGramProfile is ERC721URIStorage, DeGramWhitelist {

    /**
     * @dev Constructor function that sets the contract's name and symbol.
     */
    constructor()
        ERC721("deGram Profiles", "DGP")
    {
        
    }
    
    // Counter to keep track of the number of profiles registered.
    uint256 private _counter;

    // SVG prefix and suffix used for generating SVG images of profile names.
    string svgPrefix = '<svg xmlns="http://www.w3.org/2000/svg" width="400" height="400" fill="none"><g clip-path="url(#A)"><path d="M375 0H25C11.193 0 0 11.193 0 25v350c0 13.807 11.193 25 25 25h350c13.807 0 25-11.193 25-25V25c0-13.807-11.193-25-25-25z" fill="#000"/><g fill="#fff"><path d="M369.604 369.208c.106.765.314 1.337.625 1.716.568.689 1.541 1.034 2.92 1.034.825 0 1.496-.091 2.011-.273.977-.348 1.465-.996 1.465-1.943a1.43 1.43 0 0 0-.727-1.284c-.484-.295-1.246-.556-2.284-.784l-1.772-.397c-1.742-.394-2.946-.822-3.613-1.284-1.128-.773-1.693-1.981-1.693-3.624 0-1.5.546-2.746 1.636-3.738s2.693-1.489 4.806-1.489c1.765 0 3.27.468 4.516 1.403s1.9 2.294 1.96 4.074h-3.363c-.06-1.008-.5-1.723-1.318-2.148-.545-.28-1.223-.42-2.033-.42-.902 0-1.621.182-2.159.545s-.807.871-.807 1.523c0 .598.265 1.045.796 1.34.341.197 1.068.428 2.181.694l2.886.692c1.265.303 2.219.709 2.863 1.216 1 .788 1.5 1.928 1.5 3.42a4.82 4.82 0 0 1-1.756 3.812c-1.17 1.011-2.823 1.516-4.959 1.516-2.181 0-3.897-.498-5.147-1.494s-1.874-2.365-1.874-4.107h3.34z"/><path fill-rule="evenodd" d="M349 352v27.916h24.243v-2.571h-21.304v-22.774h21.304V352H349z"/></g><path d="M20.949 34c0-7.484 6.039-13.547 13.492-13.547S47.93 26.516 47.93 34s-6.039 13.547-13.488 13.547H22.297a1.35 1.35 0 0 1-1.348-1.352V34z" stroke="#fff" stroke-width=".901" stroke-linecap="round" stroke-dasharray="2.25 2.25"/><path d="M22.074 34c0-6.859 5.535-12.418 12.367-12.418S46.809 27.141 46.809 34 41.27 46.418 34.441 46.418H23.422a1.35 1.35 0 0 1-1.348-1.352V34z" fill="#fff"/><g fill="#000"><path d="M30.844 31.969a2.031 2.031 0 0 1 0 4.062 2.031 2.031 0 0 1 0-4.062zm7.195 0a2.031 2.031 0 0 1 0 4.062 2.031 2.031 0 0 1 0-4.062z"/></g><path d="M61.281 25.762c.391 0 .711.129.965.383s.383.59.383.996v13.953c0 .391-.125.723-.383.996-.254.254-.574.383-.965.383s-.711-.129-.969-.383a1.41 1.41 0 0 1-.383-.996v-1.105l.496.203c0 .195-.105.438-.312.723-.211.27-.496.543-.855.813s-.789.504-1.281.699a4.37 4.37 0 0 1-1.574.273c-1.035 0-1.973-.266-2.812-.793-.84-.539-1.504-1.277-2-2.211-.48-.949-.719-2.031-.719-3.254 0-1.234.238-2.316.719-3.25.496-.949 1.152-1.687 1.981-2.211a4.88 4.88 0 0 1 2.742-.816c.645 0 1.234.098 1.773.297s1.008.441 1.395.742c.406.301.715.609.922.926.227.301.34.559.34.77l-.812.293v-6.051a1.33 1.33 0 0 1 .383-.973 1.28 1.28 0 0 1 .969-.406zm-4.543 14.453c.66 0 1.238-.168 1.73-.496a3.28 3.28 0 0 0 1.148-1.355c.285-.574.426-1.211.426-1.922 0-.723-.141-1.367-.426-1.941a3.28 3.28 0 0 0-1.148-1.355c-.492-.328-1.07-.496-1.73-.496-.645 0-1.215.168-1.707.496s-.887.785-1.172 1.355c-.27.574-.402 1.219-.402 1.941 0 .711.133 1.348.402 1.922.285.57.676 1.023 1.172 1.355s1.063.496 1.707.496zm14.481 2.484c-1.277 0-2.387-.266-3.328-.793-.93-.539-1.648-1.27-2.16-2.187-.492-.918-.742-1.957-.742-3.117 0-1.355.27-2.508.809-3.457.555-.961 1.277-1.699 2.16-2.211s1.82-.769 2.809-.769a5.03 5.03 0 0 1 2.16.476 5.8 5.8 0 0 1 1.82 1.309c.527.543.938 1.176 1.238 1.899.313.723.473 1.488.473 2.301-.016.363-.16.656-.43.883s-.582.336-.941.336h-8.59l-.676-2.258h8.254l-.496.453v-.609a2.04 2.04 0 0 0-.473-1.176 2.78 2.78 0 0 0-1.035-.812c-.402-.211-.84-.316-1.305-.316a4.22 4.22 0 0 0-1.258.184c-.391.117-.727.32-1.012.609s-.508.668-.676 1.148-.246 1.094-.246 1.832c0 .813.164 1.504.496 2.078.344.555.777.984 1.305 1.285.539.285 1.109.43 1.707.43.555 0 .996-.047 1.328-.137s.59-.195.785-.316l.563-.336c.269-.137.523-.207.766-.207.328 0 .598.113.809.34.227.227.336.488.336.793 0 .406-.207.773-.629 1.105-.391.332-.937.625-1.641.879-.703.242-1.434.363-2.18.363zm15.238 0c-1.137 0-2.203-.211-3.191-.633a8.36 8.36 0 0 1-2.609-1.738c-.75-.754-1.34-1.621-1.773-2.598a7.9 7.9 0 0 1-.633-3.16c0-1.129.211-2.184.633-3.164.434-.976 1.023-1.836 1.773-2.574a8.23 8.23 0 0 1 2.609-1.762c.988-.418 2.055-.629 3.191-.629a9.28 9.28 0 0 1 2.047.223c.66.152 1.266.379 1.82.68.227.121.391.285.496.496a1.14 1.14 0 0 1 .18.609c0 .363-.121.684-.359.973a1.15 1.15 0 0 1-.922.43 1.71 1.71 0 0 1-.383-.047c-.121-.031-.238-.074-.359-.137a6.24 6.24 0 0 0-1.191-.383 6.35 6.35 0 0 0-1.328-.137c-.973 0-1.863.25-2.676.746-.793.48-1.43 1.137-1.91 1.965-.465.813-.695 1.715-.695 2.711 0 .977.23 1.879.695 2.707a5.65 5.65 0 0 0 1.91 1.988 5.16 5.16 0 0 0 2.676.723c.449 0 .945-.047 1.484-.137s.984-.211 1.328-.359l-.203.676v-3.859l.383.336h-2.496a1.37 1.37 0 0 1-.988-.383 1.3 1.3 0 0 1-.383-.969c0-.395.125-.715.383-.973.27-.254.598-.383.988-.383h3.688c.391 0 .711.133.965.406a1.3 1.3 0 0 1 .383.969v4.789c0 .301-.074.551-.223.746a1.81 1.81 0 0 1-.473.473c-.691.422-1.445.762-2.274 1.016a8.87 8.87 0 0 1-2.562.363zm9.359-.226c-.387 0-.711-.129-.965-.383a1.41 1.41 0 0 1-.383-.996V31.77a1.33 1.33 0 0 1 .383-.973c.254-.27.578-.406.965-.406s.715.137.969.406a1.33 1.33 0 0 1 .383.973v2.121l-.156-1.512c.164-.363.371-.676.629-.949.27-.285.57-.52.898-.699.328-.195.684-.34 1.055-.43s.75-.137 1.125-.137c.449 0 .824.129 1.125.387.316.254.472.555.472.902 0 .496-.129.859-.382 1.082-.254.211-.532.316-.832.316a1.92 1.92 0 0 1-.786-.156c-.226-.106-.488-.16-.789-.16-.269 0-.547.07-.832.203-.27.121-.523.316-.762.59-.227.27-.414.609-.562 1.016-.137.391-.203.859-.203 1.398v5.352a1.41 1.41 0 0 1-.383.996c-.254.254-.578.383-.969.383zm17.989-12.309c.386 0 .711.129.965.387s.382.586.382.992v9.551c0 .391-.129.723-.382.996-.254.254-.579.383-.965.383-.391 0-.715-.129-.969-.383a1.41 1.41 0 0 1-.383-.996v-1.105l.496.203c0 .195-.105.438-.316.723-.211.27-.492.543-.852.813s-.789.504-1.285.699c-.476.184-1.004.273-1.574.273a5.18 5.18 0 0 1-2.809-.793c-.84-.539-1.508-1.277-2-2.211-.48-.949-.718-2.031-.718-3.254 0-1.234.238-2.316.718-3.25.492-.949 1.153-1.687 1.977-2.211.824-.543 1.738-.816 2.742-.816.645 0 1.238.098 1.777.297a5.14 5.14 0 0 1 1.395.742c.406.301.711.609.922.926.226.301.336.559.336.77l-.809.293v-1.648a1.33 1.33 0 0 1 .383-.973c.254-.27.578-.406.969-.406zm-4.543 10.051c.66 0 1.234-.168 1.73-.496s.879-.785 1.149-1.355c.281-.574.425-1.211.425-1.922 0-.723-.144-1.367-.425-1.941-.27-.57-.653-1.023-1.149-1.355s-1.07-.496-1.73-.496c-.645 0-1.215.168-1.711.496s-.883.785-1.168 1.355c-.27.574-.406 1.219-.406 1.941 0 .711.136 1.348.406 1.922.285.57.676 1.023 1.168 1.355s1.066.496 1.711.496zm15.129-10.051c1.199 0 2.086.297 2.652.883.57.57.945 1.316 1.125 2.234l-.383-.203.18-.359c.18-.348.457-.715.832-1.109.375-.406.828-.742 1.351-1.016.539-.285 1.137-.43 1.797-.43 1.082 0 1.899.234 2.453.703.567.465.957 1.09 1.168 1.871.211.77.317 1.629.317 2.574v5.781a1.41 1.41 0 0 1-.383.996c-.254.254-.578.383-.969.383s-.711-.129-.965-.383c-.253-.273-.382-.605-.382-.996v-5.781c0-.496-.063-.937-.18-1.332-.121-.406-.34-.73-.652-.969-.317-.242-.766-.363-1.348-.363-.57 0-1.059.121-1.465.363s-.711.563-.922.969c-.195.395-.289.836-.289 1.332v5.781a1.41 1.41 0 0 1-.383.996c-.254.254-.578.383-.968.383s-.711-.129-.965-.383a1.41 1.41 0 0 1-.383-.996v-5.781c0-.496-.063-.937-.18-1.332-.121-.406-.34-.73-.652-.969s-.766-.363-1.352-.363c-.566 0-1.054.121-1.461.363-.402.238-.711.563-.922.969-.195.395-.289.836-.289 1.332v5.781a1.41 1.41 0 0 1-.382.996c-.254.254-.579.383-.969.383s-.711-.129-.965-.383c-.258-.273-.383-.605-.383-.996V31.77c0-.391.125-.715.383-.973.254-.27.574-.406.965-.406s.715.137.969.406a1.33 1.33 0 0 1 .382.973v.969l-.339-.066c.136-.254.324-.527.562-.812.242-.301.531-.578.879-.836a4.53 4.53 0 0 1 1.145-.609c.421-.164.878-.25 1.371-.25z" fill="#fff"/><g clip-path="url(#B)"><path d="M200 200c27.575 0 50-22.425 50-50s-22.425-50-50-50-50 22.425-50 50 22.425 50 50 50zm0-83.333c18.383 0 33.333 14.95 33.333 33.333s-14.95 33.333-33.333 33.333-33.334-14.95-33.334-33.333 14.95-33.333 33.334-33.333zm82.8 174.083c.508 4.575-2.534 9.25-8.3 9.25-4.192 0-7.8-3.15-8.275-7.417-3.734-33.775-32.209-59.25-66.225-59.25s-62.492 25.475-66.225 59.25c-.509 4.575-4.659 7.892-9.2 7.367-4.575-.508-7.875-4.625-7.367-9.2 4.675-42.233 40.275-74.083 82.8-74.083s78.117 31.85 82.792 74.083zm-33.8-.742c.916 4.517-2 8.909-6.509 9.825-.558.117-1.116.167-1.666.167-3.884 0-7.359-2.725-8.159-6.675-3.133-15.45-16.875-26.658-32.658-26.658s-29.525 11.208-32.658 26.658c-.917 4.508-5.284 7.442-9.825 6.508a8.34 8.34 0 0 1-6.509-9.825C155.725 266.825 176.333 250 200.008 250s44.283 16.825 48.992 40.008z" fill="#fff"/></g></g><defs><clipPath id="A"><path fill="#fff" d="M0 0h400v400H0z"/></clipPath><clipPath id="B"><path fill="#fff" transform="translate(100 100)" d="M0 0h200v200H0z"/></clipPath></defs><text x="20" y="375" font-size="20" fill="#fff" filter="url(#A)" style="font-family:&quot;Courier New&quot;,Courier,monospace;font-weight:700;position:fixed">';
    string svgSuffix = "</text></svg>";

    // Mapping from profile names to their owner's addresses.
    mapping(string => address) private _profiles;
    // Mapping from profile names to their associated records.
    mapping(string => string) private _records;
    // Mapping from addresses to a boolean indicating if they have claimed a profile.
    mapping(address => bool) private _addressClaimed;
    // Mapping from addresses to the names of profiles claimed by those addresses.
    mapping(address => string) private _getNameWithAddress;
    // Define the badge types
    enum _BadgeType {
        None,
        Human,
        Government,
        Organization,
        Star,
        Whale,
        Bot,
        Pirate
    }

    // Struct to represent a badge
    struct _Badge {
        _BadgeType _badgeType;
        string _badgeData;
    }

    // Mapping from profile names to their badges
    mapping(string => _Badge) private _badges;

    // Event to log when a badge is added to a profile
    event BadgeAdded(string profileName, _BadgeType badgeType, string badgeData);
    
    /**
     * @dev Users can register a profile by minting an NFT with a unique SVG image as the token URI. The profile's SVG image and JSON metadata are generated within this function.
     * @param name The name of the profile to register.
     */
    function register(string calldata name) public onlyWhitelisted{
        uint256 len = StringUtils.strlen(name);
        require(len >= 3 && len <= 20, "Username must be at least 3 characters long and less than 20 characters");
        require(_profiles[name] == address(0), "Name already claimed");
        require(!_addressClaimed[msg.sender], "User has already claimed a profile");
        require(StringUtils.isAlphanumeric(name), "Name must contain only small letters and numbers");
        string memory finalSvg = string(
            abi.encodePacked(svgPrefix, name, svgSuffix)
        );
        string memory json = Base64.encode(
            abi.encodePacked(
                '{"name": "',
                name,
                '", "description": "A name on the DeGram Profiles Test", "image": "data:image/svg+xml;base64,',
                Base64.encode(bytes(finalSvg)),
                '","length":"',
                Strings.toString(StringUtils.strlen(name)),
                '"}'
            )
        );
        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );
        _safeMint(msg.sender, _counter);
        _setTokenURI(_counter, finalTokenUri);
        _profiles[name] = msg.sender;
        _addressClaimed[msg.sender]=true;
        ++_counter;
        _getNameWithAddress[msg.sender] = name;
    }
    
    // Users can record information about their profiles.
    function setRecord(string calldata name, string calldata record) public {
        require(_profiles[name] == msg.sender,"You don't own this profile");
        _records[name] = record;
    }

    /**
     * @dev Override of the transferFrom function to disallow transfers.
     */
    function transferFrom(address /*from*/, address /*to*/, uint256 /*tokenId*/) public pure override(ERC721, IERC721) {
        revert("Transfers are not allowed");
    }

    /**
     * @dev Override of the approve function to disallow approvals.
     */
    function approve(address /*to*/, uint256 /*tokenId*/) public pure override(ERC721, IERC721) {
        revert("Approvals are not allowed");
    }

    /**
     * @dev Override of the setApprovalForAll function to disallow setting approvals for all.
     */
    function setApprovalForAll(address /*operator*/, bool /*approved*/)public pure override(ERC721, IERC721){
        revert("Approvals are not allowed");
    }

    // Retrieves the address that owns a particular profile.
    function profiles(string calldata _name) public view returns(address){
        return _profiles[_name];
    }

    // Retrieves the record associated with a particular profile.
    function records(string calldata _name) public view returns(string memory){
        return _records[_name];
    }

    // Checks if an address has claimed a profile.
    function addressClaimed(address _address) public view returns(bool) {
        return _addressClaimed[_address];
    }

    // Retrieves the name associated with a particular address.
    function getNameWithAddress(address _address) public view returns(string memory) {
        return _getNameWithAddress[_address];
    }
    
    /// @dev Returns the current value of the counter variable.
    /// @return The current value of the `_counter` variable, representing the count of deGram Profiles.
    function counter() public view returns(uint256){
        return _counter;
    }

    
    /** @dev Grants a badge to a user's profile, which is visible only to administrators.
      * @param profileName The unique identifier for the user's profile.
      * @param badgeType The type of the badge to be added, as defined by the `_BadgeType` enumeration.
      * @param badgeData Additional data for the badge, which can include any relevant information like reasons for awarding the badge.
      * @dev Requires that the specified profile exists and is not the zero address.
    */
    function addBadge(string calldata profileName, _BadgeType badgeType, string calldata badgeData) external onlyAdmin {
        require(_profiles[profileName] != address(0), "Profile does not exist");
        _badges[profileName] = _Badge(badgeType, badgeData);
        emit BadgeAdded(profileName, badgeType, badgeData); 
    }

    /// @dev Retrieves the badge information associated with a user's profile.
    /// @param name The unique identifier for the user's profile.
    /// @return Returns the badge data if a badge exists for the profile; otherwise, returns `address(0)`.
    function badges(string calldata name) public view returns(_Badge memory){
        return _badges[name];
    }


}