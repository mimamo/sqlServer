USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPENTEX_sALL]    Script Date: 12/21/2015 16:07:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPENTEX_sALL] @parm1 varchar (16) , @parm2 varchar (32)   as
select * from PJPENTEX
where project =  @parm1
	  and pjt_entity  like  @parm2
order by project, pjt_entity
GO
