USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJCOMMUN_init]    Script Date: 12/16/2015 15:55:26 ******/
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
