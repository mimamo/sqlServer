USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[xREAPCHK_all]    Script Date: 12/21/2015 15:43:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[xREAPCHK_all] @acct varchar(10),@sub varchar(24), @oldchknbr varchar(10),  @linenbrbeg smallint, @linenbrend smallint as
select * from xREAPCHK where
acct like @acct
and sub like @sub
and oldchknbr like @oldchknbr
and linenbr between @linenbrbeg and @linenbrend
order by Acct, Sub, OldChkNbr, Linenbr
GO
