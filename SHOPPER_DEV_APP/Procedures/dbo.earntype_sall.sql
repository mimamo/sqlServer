USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[earntype_sall]    Script Date: 12/16/2015 15:55:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[earntype_sall]
as
select * from earntype
where 1 = 1
GO
