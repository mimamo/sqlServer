USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJPROJEM_spk9]    Script Date: 12/21/2015 16:01:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPROJEM_spk9] as
select * from pjprojem
where pjprojem.project = 'Z'
GO
