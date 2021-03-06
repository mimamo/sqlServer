USE [DAL_TEST_APP]
GO
/****** Object:  Table [dbo].[Wrk941R]    Script Date: 12/21/2015 13:56:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Wrk941R](
	[AdjFedWithHeld] [float] NOT NULL,
	[AdjFICATaxes] [float] NOT NULL,
	[AdjTotFedWithHeld] [float] NOT NULL,
	[AdjTotFICATaxes] [float] NOT NULL,
	[AdvEICPayments] [float] NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[FirstMTaxes00] [float] NOT NULL,
	[FirstMTaxes01] [float] NOT NULL,
	[FirstMTaxes02] [float] NOT NULL,
	[FirstMTaxes03] [float] NOT NULL,
	[FirstMTaxes04] [float] NOT NULL,
	[FirstMTaxes05] [float] NOT NULL,
	[FirstMTaxes06] [float] NOT NULL,
	[FirstMTaxes07] [float] NOT NULL,
	[FirstMTot] [float] NOT NULL,
	[GLAddr1] [char](30) NOT NULL,
	[GLAddr2] [char](30) NOT NULL,
	[GLCity] [char](30) NOT NULL,
	[GLCpnyName] [char](30) NOT NULL,
	[GLEmplid] [char](12) NOT NULL,
	[GLState] [char](3) NOT NULL,
	[GLZip] [char](10) NOT NULL,
	[Mnth1SchB00] [float] NOT NULL,
	[Mnth1SchB01] [float] NOT NULL,
	[Mnth1SchB02] [float] NOT NULL,
	[Mnth1SchB03] [float] NOT NULL,
	[Mnth1SchB04] [float] NOT NULL,
	[Mnth1SchB05] [float] NOT NULL,
	[Mnth1SchB06] [float] NOT NULL,
	[Mnth1SchB07] [float] NOT NULL,
	[Mnth1SchB08] [float] NOT NULL,
	[Mnth1SchB09] [float] NOT NULL,
	[Mnth1SchB10] [float] NOT NULL,
	[Mnth1SchB11] [float] NOT NULL,
	[Mnth1SchB12] [float] NOT NULL,
	[Mnth1SchB13] [float] NOT NULL,
	[Mnth1SchB14] [float] NOT NULL,
	[Mnth1SchB15] [float] NOT NULL,
	[Mnth1SchB16] [float] NOT NULL,
	[Mnth1SchB17] [float] NOT NULL,
	[Mnth1SchB18] [float] NOT NULL,
	[Mnth1SchB19] [float] NOT NULL,
	[Mnth1SchB20] [float] NOT NULL,
	[Mnth1SchB21] [float] NOT NULL,
	[Mnth1SchB22] [float] NOT NULL,
	[Mnth1SchB23] [float] NOT NULL,
	[Mnth1SchB24] [float] NOT NULL,
	[Mnth1SchB25] [float] NOT NULL,
	[Mnth1SchB26] [float] NOT NULL,
	[Mnth1SchB27] [float] NOT NULL,
	[Mnth1SchB28] [float] NOT NULL,
	[Mnth1SchB29] [float] NOT NULL,
	[Mnth1SchB30] [float] NOT NULL,
	[Mnth2SchB00] [float] NOT NULL,
	[Mnth2SchB01] [float] NOT NULL,
	[Mnth2SchB02] [float] NOT NULL,
	[Mnth2SchB03] [float] NOT NULL,
	[Mnth2SchB04] [float] NOT NULL,
	[Mnth2SchB05] [float] NOT NULL,
	[Mnth2SchB06] [float] NOT NULL,
	[Mnth2SchB07] [float] NOT NULL,
	[Mnth2SchB08] [float] NOT NULL,
	[Mnth2SchB09] [float] NOT NULL,
	[Mnth2SchB10] [float] NOT NULL,
	[Mnth2SchB11] [float] NOT NULL,
	[Mnth2SchB12] [float] NOT NULL,
	[Mnth2SchB13] [float] NOT NULL,
	[Mnth2SchB14] [float] NOT NULL,
	[Mnth2SchB15] [float] NOT NULL,
	[Mnth2SchB16] [float] NOT NULL,
	[Mnth2SchB17] [float] NOT NULL,
	[Mnth2SchB18] [float] NOT NULL,
	[Mnth2SchB19] [float] NOT NULL,
	[Mnth2SchB20] [float] NOT NULL,
	[Mnth2SchB21] [float] NOT NULL,
	[Mnth2SchB22] [float] NOT NULL,
	[Mnth2SchB23] [float] NOT NULL,
	[Mnth2SchB24] [float] NOT NULL,
	[Mnth2SchB25] [float] NOT NULL,
	[Mnth2SchB26] [float] NOT NULL,
	[Mnth2SchB27] [float] NOT NULL,
	[Mnth2SchB28] [float] NOT NULL,
	[Mnth2SchB29] [float] NOT NULL,
	[Mnth2SchB30] [float] NOT NULL,
	[Mnth3SchB00] [float] NOT NULL,
	[Mnth3SchB01] [float] NOT NULL,
	[Mnth3SchB02] [float] NOT NULL,
	[Mnth3SchB03] [float] NOT NULL,
	[Mnth3SchB04] [float] NOT NULL,
	[Mnth3SchB05] [float] NOT NULL,
	[Mnth3SchB06] [float] NOT NULL,
	[Mnth3SchB07] [float] NOT NULL,
	[Mnth3SchB08] [float] NOT NULL,
	[Mnth3SchB09] [float] NOT NULL,
	[Mnth3SchB10] [float] NOT NULL,
	[Mnth3SchB11] [float] NOT NULL,
	[Mnth3SchB12] [float] NOT NULL,
	[Mnth3SchB13] [float] NOT NULL,
	[Mnth3SchB14] [float] NOT NULL,
	[Mnth3SchB15] [float] NOT NULL,
	[Mnth3SchB16] [float] NOT NULL,
	[Mnth3SchB17] [float] NOT NULL,
	[Mnth3SchB18] [float] NOT NULL,
	[Mnth3SchB19] [float] NOT NULL,
	[Mnth3SchB20] [float] NOT NULL,
	[Mnth3SchB21] [float] NOT NULL,
	[Mnth3SchB22] [float] NOT NULL,
	[Mnth3SchB23] [float] NOT NULL,
	[Mnth3SchB24] [float] NOT NULL,
	[Mnth3SchB25] [float] NOT NULL,
	[Mnth3SchB26] [float] NOT NULL,
	[Mnth3SchB27] [float] NOT NULL,
	[Mnth3SchB28] [float] NOT NULL,
	[Mnth3SchB29] [float] NOT NULL,
	[Mnth3SchB30] [float] NOT NULL,
	[NbrOfEmployees] [int] NOT NULL,
	[PrtSchB] [char](1) NOT NULL,
	[PrtSupp] [char](1) NOT NULL,
	[QtrEndDate] [smalldatetime] NOT NULL,
	[SecMTaxes00] [float] NOT NULL,
	[SecMTaxes01] [float] NOT NULL,
	[SecMTaxes02] [float] NOT NULL,
	[SecMTaxes03] [float] NOT NULL,
	[SecMTaxes04] [float] NOT NULL,
	[SecMTaxes05] [float] NOT NULL,
	[SecMTaxes06] [float] NOT NULL,
	[SecMTaxes07] [float] NOT NULL,
	[SecMTot] [float] NOT NULL,
	[ThrdMTaxes00] [float] NOT NULL,
	[ThrdMTaxes01] [float] NOT NULL,
	[ThrdMTaxes02] [float] NOT NULL,
	[ThrdMTaxes03] [float] NOT NULL,
	[ThrdMTaxes04] [float] NOT NULL,
	[ThrdMTaxes05] [float] NOT NULL,
	[ThrdMTaxes06] [float] NOT NULL,
	[ThrdMTaxes07] [float] NOT NULL,
	[ThrdMTot] [float] NOT NULL,
	[TotFedWithHeld] [float] NOT NULL,
	[TotFICATaxes] [float] NOT NULL,
	[TotMedRate] [float] NOT NULL,
	[TotMedTax] [float] NOT NULL,
	[TotMedWagesTips] [float] NOT NULL,
	[TotQtrTax] [float] NOT NULL,
	[TotSSTaxRate] [float] NOT NULL,
	[TotSSTips] [float] NOT NULL,
	[TotSSTtax] [float] NOT NULL,
	[TotSSWages] [float] NOT NULL,
	[TotSSWTax] [float] NOT NULL,
	[TotSubjWithHold] [float] NOT NULL,
	[UserID] [char](47) NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [Wrk941R0] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
