USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[earntype_sall]    Script Date: 12/21/2015 14:34:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[earntype_sall]
as
select * from earntype
where 1 = 1
GO
