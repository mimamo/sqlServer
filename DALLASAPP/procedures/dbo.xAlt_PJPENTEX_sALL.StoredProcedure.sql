USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[xAlt_PJPENTEX_sALL]    Script Date: 12/21/2015 13:45:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE procedure [dbo].[xAlt_PJPENTEX_sALL] @parm1 varchar (16) , @parm2 varchar (32)   as
select * from xAlt_PJPENTEX
where DefaultType =  @parm1
	  and pjt_entity  like  @parm2
order by DefaultType, pjt_entity
GO
