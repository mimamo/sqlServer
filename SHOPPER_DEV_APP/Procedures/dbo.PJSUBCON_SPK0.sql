USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJSUBCON_SPK0]    Script Date: 12/16/2015 15:55:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJSUBCON_SPK0]  @parm1 varchar (16) , @parm2 varchar (16)   as
select * from PJSUBCON
where    project     LIKE @parm1 and
subcontract LIKE @parm2
order by project, subcontract
GO
