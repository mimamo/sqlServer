USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJEQRATE_SEQRATE]    Script Date: 12/16/2015 15:55:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJEQRATE_SEQRATE]  @parm1 varchar (10) , @parm2 varchar (16) , @parm3 smalldatetime   as
select *
from   PJEQRATE
where  equip_id    =  @parm1
and    project     =  @parm2
and    effect_date =  @parm3
GO
