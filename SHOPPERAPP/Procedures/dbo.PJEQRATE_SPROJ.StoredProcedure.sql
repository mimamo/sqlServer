USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJEQRATE_SPROJ]    Script Date: 12/21/2015 16:13:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJEQRATE_SPROJ]  @parm1 varchar (16)  as
select *
from   PJEQRATE
where    project     =   @parm1
GO
