USE [MIDWESTAPP]
GO
/****** Object:  View [dbo].[vs_syscolumns]    Script Date: 12/21/2015 15:55:07 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create view [dbo].[vs_syscolumns] as

select id, name = convert(varchar(20), name) from syscolumns
GO
