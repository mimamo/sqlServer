USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJEQRATE_SPROJ]    Script Date: 12/16/2015 15:55:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJEQRATE_SPROJ]  @parm1 varchar (16)  as
select *
from   PJEQRATE
where    project     =   @parm1
GO
