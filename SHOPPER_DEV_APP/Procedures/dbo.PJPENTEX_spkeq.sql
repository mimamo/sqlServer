USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPENTEX_spkeq]    Script Date: 12/16/2015 15:55:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPENTEX_spkeq] @parm1 varchar (16) , @parm2 varchar (32)   as
select * from PJPENTEX
where project =  @parm1
	  and pjt_entity  =  @parm2
order by project, pjt_entity
GO
