USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJCOMMUN_init]    Script Date: 12/21/2015 15:43:01 ******/
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
