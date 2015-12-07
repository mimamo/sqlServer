-- header table
select * from xiwDonovanHdr where DonovanHdrKey = '[DonovanHdrKey]'
-- detail table there maybe be more than one record associated with the header table key
select * from xiwDonovanDtl where DonovanHdrKey = '[DonovanHdrKey]'
    
begin tran
delete from xiwdonovandtl where DonovanDtlKey in ('DonovanDtlKey')
delete from [xiwDonovanHdr] where DonovanHdrKey in ('DonovanHdrKey')
commit