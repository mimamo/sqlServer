USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJRATE_sRKeys]    Script Date: 12/21/2015 15:43:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJRATE_sRKeys]  @parm1  varchar (32) as
Select * from PJRATE
where
rate_key_value1 =  @parm1 or
rate_key_value2 =  @parm1
GO
