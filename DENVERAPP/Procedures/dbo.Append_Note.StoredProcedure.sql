USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[Append_Note]    Script Date: 12/21/2015 15:42:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[Append_Note] @keyid varchar(4), @FromID varchar(15), @ToID varchar(15) as  
set nocount on
declare @FromNid int, @FromTxtPtr varbinary(16),@FromLen int, @ToNid int, @ToTxtPtr varbinary(16), @ToLen int,@offset int, @numchars int,  
 @AppendText varchar(8000), @AddLineFeed char(1),@Hdr varchar (60) 

if @keyid = '0826' 
    begin
	select @FromNid = noteid from customer where custid = @FromID  
	select @ToNid = noteid from customer where custid = @ToId
    end
else 
    begin
	select @FromNid = noteid from vendor where vendid = @FromID
	select @ToNid = noteid from vendor where vendid = @ToID
    end
if @FromNid > 0 
    Begin
     if @keyid = '0826'
	begin		 
		set @Hdr = '* * * From Customer ID '+rtrim(@FromID)+' * * * ' +char(13)+ char(10)
		set @AddLineFeed = 'Y'
		if @ToNid = 0 
		  begin
				insert into snote (dtreviseddate, slevelname,stablename,snotetext)
				values (getdate(),'Customer','Customer','')
				select @ToNid = max(nid) from snote
				update customer set noteid = @ToNid where custid = @ToID
				set @AddLineFeed = 'N'
		  end
	 end
     else
	 begin
		set @Hdr = '* * * From Vendor ID '+rtrim(@FromID)+' * * * ' +char(13)+ char(10)
		set @AddLineFeed = 'Y'
		if @ToNid = 0 
		  begin
				insert into snote (dtreviseddate, slevelname,stablename,snotetext)
				values (getdate(),'Vendor','Vendor','')
				select @ToNid = max(nid) from snote
				update vendor set noteid = @ToNid where vendid = @ToID
				set @AddLineFeed = 'N'
		  end
	  end
	 select @FromTxtPtr =textptr(snotetext), @fromlen = datalength(snotetext)  from snote where nid = @FromNid
         if @FromTxtPtr is not null
           begin
		 if object_id( 'tempdb.dbo.#TempTxt' ) is not null drop table #TempTxt
		 create table #TempTxt (text_chunk varchar(8000))
		 set @offset = 0
		
		 while @offset <@fromlen
			begin
				set @numchars =
				   case when ((@offset + 7500) > @fromlen)  then  @fromlen - @offset
				   else 7500
				end
				insert #TempTxt exec get_text @offset, @numchars, @FromTxtPtr
		                set @offset = @offset + @numchars
		                select @AppendText =  @hdr + text_chunk from #TempTxt
				if @AddLineFeed = 'Y' set @AppendText = char(13)+ char(10) + @AppendText		
				set @AddLineFeed = 'N'
				set @Hdr = ''
				select @ToTxtPtr = textptr(snotetext) , @Tolen = datalength(snotetext) from snote where nid = @ToNid
				if @ToTxtPtr is not null
					updatetext snote.snotetext @ToTxtPtr @ToLen  0 @AppendText 
		 	end	
		 --delete from snote where nid = @fromnid
            end
    end	
    set nocount off
GO
