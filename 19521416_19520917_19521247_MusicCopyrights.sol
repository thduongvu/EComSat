pragma solidity ^0.4.23;
pragma experimental ABIEncoderV2;

contract MusicCopyrights {
    struct Songwriter {
        uint id;
        string name;
        string stageName;
        string dob;
    }

    struct Singer {
        uint id;
        string name;
        string stageName;
        string dob;
        string songName;
        string dayOfAcquisition; // Ngay so huu 
    }

    struct Song {
        uint id;
        string name;
        string releaseDate;
        string songwriterName; 
    }

    // Khoi tao danh sach ca si, ng sang tac, bai hat
    Singer[] public Singers;
    Songwriter[] public Writers;
    Song[] public Songs;
    uint SingerID = 0;
    uint WriterID = 0;
    uint SongID = 0;

    // dem so luong nguoi sang tac
    function countSongwriters() public constant returns(uint) {
        return Writers.length;
    }

    // dem so luong ca si
    function countSingers() public constant returns(uint) {
        return Singers.length;
    }

    // dem so luong bai hat
    function countSongs() public constant returns(uint) {
        return Songs.length;
    }

    // them thong tin nguoi sang tac
    function addSongwriter(string _name, string _stageName, string _dob) public returns(uint) {
        Writers.length++;
        WriterID = WriterID + 1;

        // them du lieu cho ng sang tac
        Writers[Writers.length - 1].id = WriterID; // tang index ds ng sang tac
        Writers[Writers.length - 1].name = _name;
        Writers[Writers.length - 1].stageName = _stageName;
        Writers[Writers.length - 1].dob = _dob;

        return Writers.length;
    }

    // them thong tin bai hat
    function addSong(string _name, string _releaseDate, string _songwriterName) public returns(uint) {
        for(uint i = 0; i < Writers.length; i++) {
            // kiem tra xem bai hat nay co ton tai nguoi sang tac hay khong?
            if(keccak256(bytes(Writers[i].name)) == keccak256(bytes(_songwriterName))){ 
                Songs.length++;
                SongID = SongID + 1;
                
                // them du lieu cho bai hat
                Songs[Songs.length - 1].id = SongID; // tang index ds bai hat
                Songs[Songs.length - 1].name = _name;
                Songs[Songs.length - 1].releaseDate = _releaseDate;
                Songs[Songs.length - 1].songwriterName = _songwriterName;
            } else
                revert('Songwriter does not exits');
        }
        return Songs.length;
    }

    // them thong tin ca si mua ca khuc
    function addSinger(string _name, string _stageName, string _dob, string _songName, string _dayOfAcquisition) public returns(uint) {
        Singers.length++;
        SingerID = SingerID + 1;

        // them du lieu cho ca si
        Singers[Singers.length - 1].id = SingerID; // tang index ds ca si
        Singers[Singers.length - 1].name = _name;
        Singers[Singers.length - 1].stageName = _stageName;
        Singers[Singers.length - 1].dob = _dob;
        Singers[Singers.length - 1].dayOfAcquisition = _dayOfAcquisition;
        
        // kiem tra xem ca khuc duoc mua co ton tai hay khong?
        for(uint i = 0; i < Songs.length; i++) {
            if(keccak256(bytes(Songs[i].name)) == keccak256(bytes(_songName)))
                Singers[Singers.length - 1].songName = _songName;
            else
                revert('Song does not exits');
        }
        
        return Singers.length;
    }
    
    // xoa quyen so huu bai hat cua ca si
    function deleteSingerRole(string _singerName, string _songName) public {
        for(uint i = 0; i < Singers.length; i++) {
            if(keccak256(bytes(Singers[i].songName)) == keccak256(bytes(_songName))){
                if(keccak256(bytes(Singers[i].name)) == keccak256(bytes(_singerName))) 
                    delete Singers[i];
            } 
        }
    }
    
    // get full danh sach ng sang tac
    function getListSongwriters() public view returns(Songwriter[] memory){
        return Writers;
    }

    // get full danh sach ca si
    function getListSingers() public view returns(Singer[] memory){
        return Singers;
    }

    // get full danh sach bai hat
    function getListSongs() public view returns(Song[] memory){
        return Songs;
    }
    
    // kiem tra xem ca si co dang so huu bai hat do khong, neu co thi o index nao?
    function checkCopyright(string _singerName, string _songName) view public returns(uint) {
        for(uint i = 0; i < Singers.length; i++) {
            if((keccak256(bytes(Singers[i].name)) == keccak256(bytes(_singerName))) && (keccak256(bytes(Singers[i].songName)) == keccak256(bytes(_songName)))) {
                return i;
            }
        }
        revert('Singer or Song does not exits');
    }
    
}




