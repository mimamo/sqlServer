USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJCOMMUN_init]    Script Date: 12/21/2015 14:17:48 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJCOMMUN_init]
as
SELECT * from PJCOMMUN
WHERE
msg_type = 'Z' and
msg_key = 'Z' and
msg_suffix = 'Z'
GO
