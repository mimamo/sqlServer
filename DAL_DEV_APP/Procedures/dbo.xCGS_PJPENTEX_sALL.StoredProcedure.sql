USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xCGS_PJPENTEX_sALL]    Script Date: 12/21/2015 13:35:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE procedure [dbo].[xCGS_PJPENTEX_sALL] @parm1 varchar (16) , @parm2 varchar (32)   as
select * from xCGS_PJPENTEX
where DefaultType =  @parm1
	  and pjt_entity  like  @parm2
order by DefaultType, pjt_entity
GO
