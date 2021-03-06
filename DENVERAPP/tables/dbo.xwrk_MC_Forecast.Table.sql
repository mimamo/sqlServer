USE [DENVERAPP]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO


/*******************************************************************************************************
*   DENVERAPP.dbo.xwrk_MC_Forecast
*
*   Creator:	
*   Date:		
*		
*
*   Notes:      
				select *
				from denverapp.dbo.xwrk_mc_forecast

*
*   Modifications:   
*   Developer Name      Date        Brief description
*   ------------------- ----------- ------------------------------------------------------------
*   Michelle Morales	02/05/2016 Adding primary key and non-clustered index.
********************************************************************************************************/

if (select 1
	from information_schema.tables
	where table_name = 'xwrk_MC_Forecast') < 1
	
CREATE TABLE [dbo].[xwrk_MC_Forecast](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[BusinessUnit] [varchar](50) NULL,
	[SubUnit] [varchar](50) NULL,
	[Department] [varchar](50) NULL,
	[SalesMarketing] [varchar](20) NULL,
	[fMonth] [int] NULL,
	[fPpl] [float] NULL,
	[fYear] [int] NULL,
	[fte_adj] [float] NULL,
	[adj_fPpl] [float] NULL,
	[Comments] [varchar](max) NULL
) ON [PRIMARY]
GO

SET ANSI_PADDING OFF
GO

---------------------------------------------
-- modifications
---------------------------------------------
if not exists (select *
				from sys.indexes 
				where object_id = OBJECT_ID(N'[dbo].[xwrk_MC_Forecast]') 
					and name = 'pkc_xwrk_MC_Forecast')
begin
	alter table dbo.xwrk_MC_Forecast
	ADD CONSTRAINT [pkc_xwrk_MC_Forecast] PRIMARY KEY CLUSTERED ([id])
end
go


if not exists (select *
				from sys.indexes 
				where object_id = OBJECT_ID(N'[dbo].[xwrk_MC_Forecast]') 
					and name = 'cix_xwrk_MC_Forecast')
begin

CREATE NONCLUSTERED INDEX [cix_xwrk_MC_Forecast] on [dbo].[xwrk_MC_Forecast] ([BusinessUnit], [SalesMarketing], [Department], [fMonth])
 WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 100) ON [PRIMARY]

end
go

if not exists (select *
			from sys.indexes 
			where object_id = OBJECT_ID(N'[dbo].[xwrk_MC_Forecast]') 
				and name = 'nci_xwrk_MC_Forecast')

begin				
CREATE NONCLUSTERED INDEX [nci_xwrk_MC_Forecast] ON [dbo].[xwrk_MC_Forecast]
     ([fYear], [fMonth])
 INCLUDE ([BusinessUnit], [Department], [SalesMarketing], [fPpl], [fte_adj], [adj_fPpl]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 100) ON [PRIMARY]
end
go