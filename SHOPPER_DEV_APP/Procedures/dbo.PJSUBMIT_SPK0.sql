USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJSUBMIT_SPK0]    Script Date: 12/16/2015 15:55:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJSUBMIT_SPK0]  @parm1 varchar (16) , @parm2 varchar (16) , @parm3 varchar (10)   as
select * from PJSUBMIT
where    project = @parm1 and
subcontract = @parm2 and
	     submitnbr = @parm3
GO
