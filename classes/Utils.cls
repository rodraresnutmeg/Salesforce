/**********************************************************************
History
-------
Date        AUTHOR                 	DETAIL
--/--/----  Raman Aliakevich        Initial version
02/21/2020  Kseniya Hanchuk         getQueueIdByName
***********************************************************************/

public with sharing class Utils {

    public static Map<String, Map<String, RecordType>> recordTypeMap = new Map<String, Map<String, RecordType>>();

    public static RecordType getRecordType(String sobjectType, String name) {
        if (
            recordTypeMap.containsKey(sobjectType)
            && !recordTypeMap.get(sobjectType).isEmpty()
            && recordTypeMap.get(sobjectType).get(name) != null
        ) {
            return recordTypeMap.get(sobjectType).get(name);
        }

        RecordType recordType = [
            SELECT Id, Name, DeveloperName, SobjectType
            FROM RecordType
            WHERE SobjectType = :sobjectType AND DeveloperName = :name
            LIMIT 1
        ];

        if (recordTypeMap.containsKey(sobjectType) && !recordTypeMap.get(sobjectType).isEmpty()) {
            recordTypeMap.get(sobjectType).put(name, recordType);
        } else {
            Map<String, RecordType> rtMap = new Map<String, RecordType>();
            rtMap.put(name, recordType);
            recordTypeMap.put(sobjectType, rtMap);
        }

        return recordType;
    }

    public static List<String> getNormalizedListFromString(String str) {
        if (str == null) {
            return null;
        }

        List<String> stringsBeforeNormalize = new List<String>(str.split(','));
        List<String> stringsAfterNormalize  = new List<String>();

        for(String s : stringsBeforeNormalize) {
            stringsAfterNormalize.add(s.normalizeSpace());
        }

        return stringsAfterNormalize;
    }

    public static String getEncodedCaseId(Id caseId) {
        if (caseId == null) {
            return null;
        }

        Blob decrypted = Blob.valueOf(caseId);
        Blob encrypted = Crypto.encryptWithManagedIV('AES128', getSecretKey(), decrypted);

        return EncodingUtil.urlEncode(EncodingUtil.base64Encode(encrypted),'UTF-8');
    }

    public static String getDecodedCaseId(String encodedCaseId) {
        if (encodedCaseId == null) {
            return null;
        }

        Blob encrypted = EncodingUtil.base64Decode(encodedCaseId);
        Blob decrypted = Crypto.decryptWithManagedIV('AES128', getSecretKey(), encrypted);

        return decrypted.toString();
    }

    public static Id getQueueIdByName(String queueName) {
        if (String.isBlank(queueName))
            return null;

        return [
            SELECT Id
            FROM Group
            WHERE Type = 'Queue'
            AND DeveloperName = :queueName
            LIMIT 1
        ].Id;

    }


    private static Blob getSecretKey() {
        return Blob.valueOf(String.valueOf(UserInfo.getOrganizationId()).substring(0, 16));
    }

}