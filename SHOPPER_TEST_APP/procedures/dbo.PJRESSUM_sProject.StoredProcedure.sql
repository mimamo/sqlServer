USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJRESSUM_sProject]    Script Date: 12/21/2015 16:07:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJRESSUM_sProject] @parm1 varchar (16)   as
select * from PJRESSUM
where    PJRESSUM.project        =   @parm1
order by project,
PJRESSUM.pjt_entity,
PJRESSUM.acct,
PJRESSUM.resource_type,
PJRESSUM.employee,
PJRESSUM.subcontractor,
PJRESSUM.resource_id
GO
