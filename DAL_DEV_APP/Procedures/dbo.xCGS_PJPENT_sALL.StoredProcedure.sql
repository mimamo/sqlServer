USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xCGS_PJPENT_sALL]    Script Date: 12/21/2015 13:35:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE procedure [dbo].[xCGS_PJPENT_sALL] @parm1 varchar (16) , @parm2 varchar (32)   as
select * from xCGS_PJPENT, xCGS_PJPENTEX
where xCGS_PJPENT.DefaultType = xCGS_PJPENTEX.DefaultType and 
xCGS_PJPENT.pjt_entity = xCGS_PJPENTEX.pjt_entity and 
xCGS_PJPENT.DefaultType =  @parm1 and 
xCGS_PJPENT.pjt_entity  like  @parm2
order by xCGS_PJPENT.DefaultType, xCGS_PJPENT.pjt_entity
GO
