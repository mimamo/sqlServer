USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[xCGS_PJPENT_spk4]    Script Date: 12/21/2015 13:45:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE procedure [dbo].[xCGS_PJPENT_spk4] @parm1 varchar (16) , @parm2 varchar (32)   as
select * from xCGS_PJPENT, PJEMPLOY, xCGS_PJPENTEX
where    xCGS_pjpent.DefaultType         =     @parm1
and    xCGS_pjpent.pjt_entity      like  @parm2
and    xCGS_PJPENT.manager1 *= PJEMPLOY.employee  
and    xCGS_PJPENT.DefaultType *= xCGS_PJPENTEX.DefaultType   
and    xCGS_PJPENT.pjt_entity *= xCGS_PJPENTEX.pjt_entity   
order by
xCGS_pjpent.DefaultType,
xCGS_pjpent.pjt_entity
GO
