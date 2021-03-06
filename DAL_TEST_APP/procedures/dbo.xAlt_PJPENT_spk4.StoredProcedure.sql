USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[xAlt_PJPENT_spk4]    Script Date: 12/21/2015 13:57:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[xAlt_PJPENT_spk4] @parm1 varchar (16) , @parm2 varchar (32)   as
select * from xAlt_PJPENT, PJEMPLOY, xAlt_PJPENTEX
where    xAlt_pjpent.DefaultType         =     @parm1
and    xAlt_pjpent.pjt_entity      like  @parm2
and    xAlt_PJPENT.manager1 *= PJEMPLOY.employee  
and    xAlt_PJPENT.DefaultType *= xAlt_PJPENTEX.DefaultType   
and    xAlt_PJPENT.pjt_entity *= xAlt_PJPENTEX.pjt_entity   
order by
xAlt_pjpent.DefaultType,
xAlt_pjpent.pjt_entity
GO
