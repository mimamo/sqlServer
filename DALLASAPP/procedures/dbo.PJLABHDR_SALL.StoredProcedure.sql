USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJLABHDR_SALL]    Script Date: 12/21/2015 13:45:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJLABHDR_SALL] @parm1 varchar (10)   as
select * from PJLABHDR
where    docnbr  LIKE @parm1
order by docnbr
GO
