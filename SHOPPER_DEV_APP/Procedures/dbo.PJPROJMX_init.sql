USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPROJMX_init]    Script Date: 12/16/2015 15:55:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPROJMX_init]
as
select * from PJPROJMX  where
project     =  'Z' and
pjt_entity    = 'Z' and
acct = 'Z'
GO
