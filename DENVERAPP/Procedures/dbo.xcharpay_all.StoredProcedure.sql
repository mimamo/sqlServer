USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[xcharpay_all]    Script Date: 12/21/2015 15:43:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[xcharpay_all] @custid varchar(15), @oldpaynbr varchar(10), @linenbrbeg smallint, @linenbrend smallint
as select * from xcharpay
where custid like @custid
and oldpaynbr like @oldpaynbr
and linenbr between @linenbrbeg and @linenbrend
GO
