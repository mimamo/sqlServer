USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[xkcCustInv_all]    Script Date: 12/21/2015 15:43:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[xkcCustInv_all] @invnbr varchar(10) as
select * from xkcCustInv
where invnbr like @invnbr
order by invnbr
GO
