USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[xkcOrder_delete]    Script Date: 12/21/2015 15:37:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[xkcOrder_delete] @cpnyid varchar(10)  as
delete from xkcOrder where cpnyid = @cpnyid
GO
