USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJCONTRL_utr0]    Script Date: 12/21/2015 14:17:48 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJCONTRL_utr0]  @parm1 varchar (255)   as
update PJCONTRL
set control_data = @parm1
where
control_type = 'PA' and
control_code = 'TRAN-RUN'
GO
