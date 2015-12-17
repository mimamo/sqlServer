USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJRESSUM_sProject]    Script Date: 12/16/2015 15:55:28 ******/
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
