USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJCONTRL_SPK3]    Script Date: 12/21/2015 15:37:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PJCONTRL_SPK3]
	@control_type varchar(2),
	@control_code varchar(30),
	@control_data varchar(255) output
as

declare @lControlData varchar(255)

select @lControlData = control_data from PJCONTRL
where control_type = @control_type
and control_code = @control_code

select @control_data = @lControlData
GO
