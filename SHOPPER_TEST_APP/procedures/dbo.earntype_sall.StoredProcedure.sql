USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[earntype_sall]    Script Date: 12/21/2015 16:07:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[earntype_sall]
as
select * from earntype
where 1 = 1
GO
