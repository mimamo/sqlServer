USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Notes_from_to]    Script Date: 12/21/2015 14:06:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[Notes_from_to] @keyid varchar(4)as
/*purpose is to first determine from /to for purposes of appending notes, in particular where newTO appearing in multiple records in KC21chg.  Here the
noteid of the first FROM record will survive automatically, so all subsequent records are appended to that first FROM record */
set nocount on
if object_id( 'tempdb.dbo.#Chg1' ) is not null drop table #Chg1 if object_id( 'tempdb.dbo.#Chg2' ) is not null drop table #Chg2
/*get all regardless of whether fromkey has a noteid*/
select fromkey, tokey,  flag = case when tokey not in (select custid from customer) then 1 end, gridorder into #Chg1 from KC21CHG  where  keyid = @keyid 
delete from #Chg1 where  flag = 1 and tokey in (select tokey from #Chg1 group by tokey having count(*) = 1)  
select tokey ,  gridorder = min(gridorder), newtokey = space(15)  into #Chg2 from #Chg1 where flag = 1 group by tokey update #chg2 set newTokey = (select fromkey from #chg1 where #chg1.gridorder = #chg2.gridorder)
update #Chg1 set tokey =  N.newToKey  from #Chg1 T, #Chg2 N where T.tokey = N.tokey and flag = 1 
delete #chg1 from #chg1 C1, customer C2 where C1.fromkey = C2.custid and C2.noteid = 0 or (C1.fromkey = C1.tokey)
declare CSR_note cursor for select fromkey, tokey from #Chg1 order by gridorder
declare @from char(15), @to char(15)
open CSR_note
fetch next from CSR_note into @from, @to
begin
  while @@fetch_status = 0
	begin
	 exec append_note @keyid, @from, @to
         fetch next from CSR_note into @from, @to
        end
end
close CSR_note
deallocate CSR_note
set nocount off
GO
