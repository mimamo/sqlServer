USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPENTXREFMSP_spk0]    Script Date: 12/16/2015 15:55:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPENTXREFMSP_spk0] @parm1 varchar (16) , @parm2 varchar (32)   as
select PJPENTXREFMSP.Pjt_Entity_MSPID
From	PJPENTXREFMSP
where  PJPENTXREFMSP.project         =     @parm1
and    PJPENTXREFMSP.pjt_entity      =	   @parm2
order by
PJPENTXREFMSP.project,
PJPENTXREFMSP.pjt_entity
GO
