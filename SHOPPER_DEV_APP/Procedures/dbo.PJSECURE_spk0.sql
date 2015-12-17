USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJSECURE_spk0]    Script Date: 12/16/2015 15:55:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJSECURE_spk0] @parm1 varchar (4) , @parm2 varchar (64)  as
select * from PJSECURE
where PW_TYPE_CD = @parm1 and
	KEY_VALUE = @parm2
order by pw_type_cd, key_value
GO
