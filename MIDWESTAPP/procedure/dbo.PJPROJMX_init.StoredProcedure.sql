USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJPROJMX_init]    Script Date: 12/21/2015 15:55:38 ******/
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
